import yaml
from jinja2 import Environment, FileSystemLoader

with open('yaml/jinja_data.yaml', 'r') as file:
    data = yaml.safe_load(file)

file_loader = FileSystemLoader('jinja/')
env = Environment(loader=file_loader)

template = env.get_template('jinja_template.j2')

print(template.render(data))