import yaml

def create_yaml():
    data = {
        'name': 'ABV',
        'age': 35,
        'city': 'KC'
    }

    with open('new.yaml', 'w') as file:
        yaml.dump(data, file)

def validate_yaml():
    try:
        with open('new.yaml', 'r') as file:
            data = yaml.safe_load(file)
        print("Valid YAML")
        return data
    except yaml.YAMLError as exc:
        print("YAML error:", exc)
        return None    

def parse_yaml(data):
    if data:
        print("Name: ", data['name'])
        print("City: ", data['city'])
        print("Age: ", data['age'])

if __name__ == "__main__":
    create_yaml()
    data = validate_yaml()
    parse_yaml(data)