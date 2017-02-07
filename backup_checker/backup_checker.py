from boto.s3.connection import S3Connection
from datetime import timedelta
from datetime import datetime
import time
import random
import requests

'''
    Simple script to check the status of periodic backups in S3 buckets & notify in a slack channel!
    Author: Angelo Poerio <angelo.poerio@gmail.com>
'''


AWS_KEY = '' # put here your aws key
AWS_SECRET = '' # put here your aws secret
SLACK_ENDPOINT = '' # put here your slack endpoint
MASTER_BUCKET = '' # put here the father bucket containing your backups
BUCKETS_TO_CHECK = [] # children buckets
THRESHOLD = timedelta(hours=24)
aws_connection = S3Connection(AWS_KEY, AWS_SECRET)

def slack_notifier(msg):
    time.sleep(random.randint(1, 10)) # here to fool the slack API and avoid to be banned :)
    json_to_send = {'text': msg,
                    'channel': '', # put here the name of your slack channel
                    'username': 'backup-bot'}
    return requests.post(SLACK_ENDPOINT, json=json_to_send)

def check_bucket(bucket_name):
    bucket = aws_connection.get_bucket(MASTER_BUCKET, validate=False)
    files = bucket.list(prefix=bucket_name)
    
    if not files:
        slack_notifier('WARNING!!! {0} bucket is EMPTY!!!!!'.format(bucket_name))
        return
    
    most_recent = time.strptime(max([f.last_modified for f in files])[:-5], "%Y-%m-%dT%H:%M:%S")

    if (datetime.now()-datetime(*most_recent[:6])) > THRESHOLD:
        slack_notifier('WARNING!!! the last file in the bucket {0} is older than 24 hours'.format(bucket_name))
        return    

    slack_notifier('bucket {0} is ok!'.format(bucket_name))


if __name__ == '__main__':
    for bucket in BUCKETS_TO_CHECK:
        try:
            check_bucket(bucket)
        except Exception as ex:
            slack_notifier('PANIC! Exception while fetching informations about the bucket {0}'.format(bucket))
