# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Polaris::Application.config.secret_key_base = 'bafc6ebfd681d54a6c8fc1c407a17c6377e6c9d878508e20bfdcafe60423df5cbf9550e3bdf86358498420ef90789d118e55193426d4e9d64a49d8777feccd19'
