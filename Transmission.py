import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timedelta
import pytz

try:
    # Try to get the app instance
    app = firebase_admin.get_app()
except ValueError:
    # Initialize Firebase with credentials and a unique app name
    cred = credentials.Certificate({
       "Your Firebase Credentials"
    })
    app = firebase_admin.initialize_app(cred, name='digital-water-billing-system')

# Access Firestore database using the initialized app instance
db = firestore.client(app=app)


# Now you can continue with your existing code using 'db' to interact with Firestore







def calculate_admin_monthly_totals(admin_user_id):
    try:
        # Initialize Firestore client

        # Define PKT timezone
        pkt_timezone = pytz.timezone('Asia/Karachi')

        # Get current PKT datetim
        now_pkt = datetime.now(pkt_timezone)

        # Define current month in 'YYYY-MM' format
        current_month = now_pkt.strftime('%Y-%m')

        # Access the Firestore collection of users
        collection = db.collection('users')
        user_docs = collection.stream()

        # Initialize admin monthly totals
        admin_monthly_totals = {
            'monthly_bill': 0,
            'monthly_total': 0
        }

        for doc in user_docs:
            user_data = doc.to_dict()

            # Check if the user is a Customer and has monthly usage data
            if user_data.get('roleType') == 'Customer' and 'monthly_usage' in user_data:
                monthly_usage = user_data['monthly_usage']

                # Check if the current month exists in the customer's monthly usage data
                if current_month in monthly_usage:
                    # Accumulate monthly bill and total
                    admin_monthly_totals['monthly_bill'] += monthly_usage[current_month]['monthly_bill']
                    admin_monthly_totals['monthly_total'] += monthly_usage[current_month]['monthly_total']

        # Construct the new monthly_usage data for admin
        monthly_usage_data = {
            current_month: {
                'monthly_bill': round(admin_monthly_totals['monthly_bill'], 4),
                'monthly_total': round(admin_monthly_totals['monthly_total'], 4)
            }
        }

        # Update the 'monthly_usage' field in the admin's document
        admin_doc_ref = collection.document(admin_user_id)
        admin_doc_ref.update({
            'monthly_usage': monthly_usage_data
        })

        print(f"Admin's monthly usage updated for {current_month}: {monthly_usage_data}")

    except Exception as e:
        print(f'Error calculating admin monthly totals: {e}')








def get_current_month():
    # Define PKT timezone
    pkt_timezone = pytz.timezone('Asia/Karachi')

    # Get current UTC time
    now_utc = datetime.utcnow()

    # Convert UTC time to PKT timezone
    now_pkt = now_utc.replace(tzinfo=pytz.utc).astimezone(pkt_timezone)

    # Format current PKT time as 'YYYY-MM' for month-year representation
    current_month = now_pkt.strftime('%Y-%m')

    return current_month













def get_daily_usage(user_id):
    try:
        user_doc = db.collection('users').document(user_id).get()

        if user_doc.exists:
            decoded_payload = user_doc.get('decoded_payload')  # Correct usage: only pass field name
            total = user_doc.get('total')
            total += decoded_payload
            total = total/2

            return total

    except Exception as e:
        print(f'Error retrieving daily usage: {e}')

    return None















def calculate_admin_daily_totals(admin_user_id):
    try:
        # Define PKT timezone
        pkt_timezone = pytz.timezone('Asia/Karachi')

        # Get current PKT datetime
        now_pkt = datetime.now(pkt_timezone)

        # Define current month and date in 'YYYY-MM' and 'YYYY-MM-DD' format
        current_month = now_pkt.strftime('%m-%Y')  # Format current month as '05-2024'
        current_date = now_pkt.strftime('%Y-%m-%d')

        # Access the Firestore collection of users
        collection = db.collection('users')
        user_docs = collection.stream()

        # Retrieve admin's document to update daily usage
        admin_doc_ref = collection.document(admin_user_id)
        admin_data = admin_doc_ref.get().to_dict()
        admin_daily_totals = admin_data.get('daily_usage', {})

        # Reset the daily total for the current date to 0
        if current_month not in admin_daily_totals:
            admin_daily_totals[current_month] = {}
        admin_daily_totals[current_month][current_date] = 0.0

        for doc in user_docs:
            user_data = doc.to_dict()

            # Check if the user is a Customer and has daily usage data
            if user_data.get('roleType') == 'Customer' and 'daily_usage' in user_data:
                daily_usage = user_data['daily_usage']

                # Check if the current month exists in the customer's daily usage data
                if current_month in daily_usage:
                    # Check if the current date exists in the daily usage for the current month
                    if current_date in daily_usage[current_month]:
                        # Accumulate daily total
                        admin_daily_totals[current_month][current_date] += daily_usage[current_month][current_date]

        # Update the 'daily_usage' field in the admin's document
        admin_doc_ref.update({
            'daily_usage': admin_daily_totals
        })

        print(f"Admin's daily usage updated for {current_date}: {admin_daily_totals.get(current_month, {}).get(current_date, 0.0)}")

    except Exception as e:
        print(f'Error calculating admin daily totals: {e}')















def reset_daily_usage(user_id):
    try:
        # Define Pakistan Standard Time (PKT) timezone
        pkt_timezone = pytz.timezone('Asia/Karachi')

        # Get current UTC time
        now_utc = datetime.utcnow()

        # Convert UTC time to PKT
        now_pkt = now_utc.replace(tzinfo=pytz.utc).astimezone(pkt_timezone)

        # Format current date and time in PKT
        current_date = f'{now_pkt.year}-{now_pkt.month:02d}-{now_pkt.day:02d}'
        current_time = now_pkt.strftime("%Y-%m-%d %H:%M:%S")
        print(current_time)  # Print PKT time for debugging

        # Retrieve current daily usage
        current_total = get_daily_usage(user_id)

        if current_total is not None:
            month_year_key = f"{now_pkt.month:02d}-{now_pkt.year:02d}"
            
            # Get user document from Firestore
            user_doc = db.collection('users').document(user_id).get()
            monthly_usage = user_doc.get('daily_usage') or {}

            # Ensure monthly_usage dictionary is properly initialized
            monthly_usage[month_year_key] = monthly_usage.get(month_year_key, {})

            formatted_current_total = round(current_total,4)

            if current_date not in monthly_usage[month_year_key]:
                monthly_usage[month_year_key][current_date] = 0.0

            # Add the current total to the existing or initialized value for the current date
            monthly_usage[month_year_key][current_date] += round(float(formatted_current_total),4)

            # Update the 'daily_usage' field in the user document
            db.collection('users').document(user_id).update({
                'daily_usage': monthly_usage
            })

            calculate_monthly_totals(user_id)
        else:
            print('Error: Failed to retrieve daily usage.')
    except Exception as e:
        print(f'Error resetting daily total: {e}')














def get_admin_billing_rate():
    try:
        admin_query = db.collection('users').where('roleType', '==', 'Admin')
        admin_user_ref = admin_query.limit(1).get()
        
        if admin_user_ref:
            admin_user_doc = admin_user_ref[0]
            admin_user_data = admin_user_doc.to_dict()
            if 'billingRate' in admin_user_data:
                billing_rate = admin_user_data['billingRate']
                # Convert billing rate to float if it's a string
                if isinstance(billing_rate, str):
                    billing_rate = float(billing_rate)
                return billing_rate

        # If no admin user document found or no billing rate found, return a default value
        return 8.0  # Default billing rate if no admin rate is found
    except Exception as e:
        print(f'Error fetching admin billing rate: {e}')
        return 8.0  # Default value in case of error


















def calculate_monthly_totals(user_id):
    try:
        pkt_timezone = pytz.timezone('Asia/Karachi')
        now_utc = datetime.utcnow()
        now_pkt = now_utc.replace(tzinfo=pytz.utc).astimezone(pkt_timezone)
        current_month_year = f"{now_pkt.year:02d}-{now_pkt.month:02d}"

        user_ref = db.collection('users').document(user_id)
        user_doc = user_ref.get()

        if user_doc.exists:
            # Get the billing rate based on the admin user's rate
            billing_rate = get_admin_billing_rate()

            monthly_usage = user_doc.get('monthly_usage') or {}
            monthly_usage[current_month_year] = monthly_usage.get(current_month_year, {})
            monthly_total = 0.0

            daily_usage = user_doc.get('daily_usage')
            if daily_usage and daily_usage.get(f"{now_pkt.month:02d}-{now_pkt.year:02d}"):
                monthly_daily_usage = daily_usage[f"{now_pkt.month:02d}-{now_pkt.year:02d}"]

                for usage in monthly_daily_usage.values():
                    if isinstance(usage, (int, float)):
                        monthly_total += usage

                monthly_total = round(monthly_total, 2)
                monthly_bill = monthly_total * billing_rate

                # Update monthly totals and bill in the monthly_usage dictionary
                monthly_usage[current_month_year]['monthly_total'] = monthly_total
                monthly_usage[current_month_year]['monthly_bill'] = monthly_bill

                # Update the 'monthly_usage' field in the user document
                user_ref.update({
                    'monthly_usage': monthly_usage
                })

                print(f'Monthly totals updated successfully for {current_month_year}:', monthly_usage)
            else:
                print(f'No daily usage data found for {current_month_year}')
        else:
            print(f'User document does not exist for {user_id}')
    except Exception as e:
        print(f'Error calculating and updating monthly totals: {e}')















def check_user_document(user_id):
    user_doc = db.collection('users').document(user_id).get()

    if not user_doc.exists:
        create_user_document(user_id)
    else:
        user_data = user_doc.to_dict()
        document_updated = False

        if 'daily_usage' not in user_data:
            user_data['daily_usage'] = {}
            document_updated = True

        if 'monthly_usage' not in user_data:
            user_data['monthly_usage'] = {}
            document_updated = True

        if document_updated:
            user_doc.reference.update(user_data)

def create_user_document(user_id):
    db.collection('users').document(user_id).set({
        'total': 0.0,
        'daily_usage': {},
        'monthly_usage': {}
    })





def check_and_calculate_monthly_totals(user_id):
    pkt_timezone = pytz.timezone('Asia/Karachi')

        # Get current UTC time
    now_utc = datetime.utcnow()

        # Convert UTC time to PKT
    now_pkt = now_utc.replace(tzinfo=pytz.utc).astimezone(pkt_timezone)

    calculate_monthly_totals(user_id)










def handler(pd:"pipedream"):
    try:
        # Reference data from previous steps
        print(pd.steps["trigger"]["context"]["id"])
        
        collection = db.collection('users')
        user_docs = collection.get()

        for doc in user_docs:
            user_data = doc.to_dict()
            user_id = doc.id

            if user_data.get('roleType') == 'Customer' and user_data.get('dev_eui') == pd.steps['trigger']['event']['body']['end_device_ids']['dev_eui']:
                decoded_payload = pd.steps['trigger']['event']['body']['uplink_message']['decoded_payload']['count']
                new_total = pd.steps['trigger']['event']['body']['uplink_message']['decoded_payload']['count']
                decoded_payload = round(decoded_payload,4)
                new_total = round(new_total,4)

                collection.document(user_id).update({
                    'decoded_payload': decoded_payload,
                    'total': decoded_payload
                })

                # After Firestore update, execute other async functions
                check_user_document(user_id)
                reset_daily_usage(user_id)
                check_and_calculate_monthly_totals(user_id)
              
                # UserID = 'jE8fFOYN6STsADllW8Qs1sOAJ6R2'
                # calculate_admin_daily_totals(UserID)
                # calculate_admin_monthly_totals(UserID)
              
            elif user_data.get('roleType')  == 'Admin' and user_data.get('dev_eui') == pd.steps['trigger']['event']['body']['end_device_ids']['dev_eui']:
              
                decoded_payload = pd.steps["trigger"]["event"]["body"]["uplink_message"]["decoded_payload"]["TURBIDITY"]
                new_total = pd.steps["trigger"]["event"]["body"]["uplink_message"]["decoded_payload"]["PH"]
                decoded_payload = round(decoded_payload,4)
                new_total = round(new_total,4)

                collection.document(user_id).update({
                    'turbidity': decoded_payload,
                    'pH': new_total
                })

                calculate_admin_daily_totals(user_id)
                calculate_admin_monthly_totals(user_id)

    except Exception as error:
        print('Error in run method:', error)
