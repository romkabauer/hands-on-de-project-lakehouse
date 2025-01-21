import setuptools

setuptools.setup(
    name='ingest-expenses-beam-app',
    version='0.1.0',
    install_requires=[
        'apache_beam==2.61.0'
    ],
    packages=['ingest_expenses_beam_app']
)
