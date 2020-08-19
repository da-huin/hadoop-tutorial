import happybase

connection = happybase.Connection('localhost', 9090)
connection.create_table('table-name', {'family': dict()})
connection.tables()
table = connection.table('table-name')
table.put('row-key', {'hello':'world', 'yellow': 'banana'})
for k, data in table.scan():
    print(k, data)