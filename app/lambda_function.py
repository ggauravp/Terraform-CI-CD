import boto3
import csv
import psycopg2
import os
import socket

print("Lambda function has started execution")
print("Imports completed")

def lambda_handler(event, context):
    try:
        # Test if Lambda can reach your EC2 Postgres
        sock = socket.socket()
        result = sock.connect_ex((os.environ["DB_HOST"], 5432))
        print("Connection test result:", result)  # 0 = can connect, non-zero = cannot
        sock.close()
    except Exception as e:
        print("Error testing DB connection:", e)
        return {"status": "DB connection test failed", "error": str(e)}

    try:
        bucket = event["Records"][0]["s3"]["bucket"]["name"]
        key    = event["Records"][0]["s3"]["object"]["key"]

        s3 = boto3.client("s3")
        obj = s3.get_object(Bucket=bucket, Key=key)

        rows = obj["Body"].read().decode("utf-8").splitlines()
        csv_reader = csv.reader(rows)
        print("CSV file read successfully")
    except Exception as e:
        print("Error reading CSV from S3:", e)
        return {"status": "S3 read failed", "error": str(e)}

    try:
        conn = psycopg2.connect(
            host=os.environ["DB_HOST"],
            user=os.environ["DB_USER"],
            password=os.environ["DB_PASS"],
            database=os.environ["DB_NAME"]
        )
        print("Database connection established")
    except Exception as e:
        print("Error connecting to PostgreSQL:", e)
        return {"status": "DB connection failed", "error": str(e)}

    try:
        cur = conn.cursor()
        for row in csv_reader:
            cur.execute("INSERT INTO table_name (col1, col2, col3) VALUES (%s, %s, %s)", row)

        conn.commit()
        cur.close()
        conn.close()
        print("Data inserted successfully")
    except Exception as e:
        print("Error inserting data into PostgreSQL:", e)
        return {"status": "DB insert failed", "error": str(e)}

    return {"status": "Done"}
