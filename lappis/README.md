# Lapis example

Install [**OpenResty**](https://openresty.org/en/linux-packages.html) first, it is required. If Lapis was installed locally,
```sh
luarocks install --local lapis
echo 'eval $(luarocks path --local)' >> ~/.bashrc
source ~/.bashrc
```

In your directory, replace `app.lua` with your code after running,
```sh
lapis new --lua # similar to npx create-react-app
# Starts the server and keeps it running in your terminal
lapis server
```