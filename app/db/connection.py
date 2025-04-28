import pyodbc
from fastapi import HTTPException
from app.core.config import settings
from app.core.logging_config import logger

# Connection pool for better performance and reliability
CONNECTION_POOL = []

def get_db_connection():
    """Get a connection from the pool or create a new one if necessary"""
    if CONNECTION_POOL:
        try:
            conn = CONNECTION_POOL.pop()
            # Test if connection is still valid
            conn.execute("SELECT 1")
            return conn
        except:
            # Connection was stale, create new one
            pass
    
    # Create new connection
    connection_string = (
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"SERVER={settings.DB_SERVER};"
        f"DATABASE={settings.DB_NAME};"
        f"UID={settings.DB_USERNAME};"
        f"PWD={settings.DB_PASSWORD};"
        f"Connection Timeout={settings.CONN_TIMEOUT};"
        f"Encrypt={settings.ENCRYPT};"
        f"TrustServerCertificate=no"
    )
    
    try:
        conn = pyodbc.connect(connection_string)
        return conn
    except Exception as e:
        logger.error(f"Database connection error: {str(e)}")
        raise HTTPException(status_code=503, detail="Database service unavailable")

def return_connection(conn):
    """Return a connection to the pool"""
    if len(CONNECTION_POOL) < settings.MAX_POOL_SIZE:
        try:
            # Make sure connection is still good
            conn.execute("SELECT 1")
            CONNECTION_POOL.append(conn)
        except:
            # If connection is bad, close it
            try:
                conn.close()
            except:
                pass
    else:
        try:
            conn.close()
        except:
            pass
