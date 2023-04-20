import logging
import sys
import boto3
from botocore.exceptions import ClientError


def create_custom_data_identifiers(client, custom_data_identifiers_list, tags_list):

    for item in custom_data_identifiers_list:

        response = client.create_custom_data_identifier(
            # clientToken='string',
            name=item['name'],
            description=item['description'],
            maximumMatchDistance=50,
            regex=item['regex'],
            severityLevels=[
                {
                    'occurrencesThreshold': 1,
                    'severity': 'MEDIUM'
                },
            ],
            tags=tags_list
        )

# ------------------------------------------------------------#


def list_custom_data_identifiers(macie_client):
    """Returns a list of all custom data identifier ids"""

    custom_data_identifiers = []

    try:
        response = macie_client.list_custom_data_identifiers()
        for item in response['items']:
            custom_data_identifiers.append(item['id'])
        return custom_data_identifiers
    except ClientError as e:
        logging.error(e)
        sys.exit(e)
