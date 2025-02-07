from jinja2 import Environment, FileSystemLoader

file_loader = FileSystemLoader('../jinja/')
env = Environment(loader=file_loader)

template = env.get_template('first.j2')

context = {
    'name': 'Joe',
    'notifications': 5
}

print(template.render(context))