
from monecole_ws import settings
from twilio.rest import Client
def send_whatssap_message(variable,receiver_phone_number):
    account_sid = settings.TWILIO_ACCOUNT_SID
    auth_token = settings.TWILIO_AUTH_TOKEN
    client = Client(account_sid, auth_token)
   
    client.messages.create(
        from_="whatsapp:"+settings.TWILIO_PHONE_NUMBER,
        to="whatsapp:"+receiver_phone_number,
        content_sid=settings.CONTENT_TEMPLATE_SID,
        content_variables='{"1": "'+variable+'"}'
    )

"""
client.messages.create(
        to=receiver_phone_number,
        messaging_service_sid=settings.TWILIO_MESSAGING_SERVICE_SID,
        body=msg,
    )
"""
    

    #to=receiver_phone_number,
    #messaging_service_sid=settings.TWILIO_MESSAGING_SERVICE_SID,
