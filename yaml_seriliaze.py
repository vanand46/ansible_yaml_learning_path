import yaml

# Create python dictionary
data = {
    'title': 'YAML Serialization Example',
    'version': '1.0',
    'items': ['item1', 'item2', 'item3']
}

# Serialize the dictionary to YAML file
with open('serial_output.yaml', 'w') as file:
    yaml.dump(data, file)

print('Data Serialization complete')