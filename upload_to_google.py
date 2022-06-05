from pydrive.drive import GoogleDrive
from pydrive.auth import GoogleAuth


import os

gauth = GoogleAuth()

gauth.LocalWebserverAuth()
drive = GoogleDrive(gauth)

path = "/path/to/data"


for file in os.listdir(path):
    print(file)
    f = drive.CreateFile({'title': file, 'parents': [{'id': 'id'}]})
    #f = drive.CreateFile({'title': file})
    f.SetContentFile(os.path.join(path, file))
    f.Upload()
  
    f = None
