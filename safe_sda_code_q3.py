import json

with open('C:\\Users\\USER\\Downloads\\Test_File.json') as file:
    data = json.load(file)
    
str = '"name": "WalletConnect"'
x=0

for i in range(len(data['results'])):
    if str in (data['results'][i]['origin']):
        x=x+1
print("the number of WalletConnect transaction(s) is/are",x)