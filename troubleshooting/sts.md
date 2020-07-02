Anon is right about STS, but there is a way to specifically delete your domain from the set.

Go to `chrome://net-internals/#hsts`. Enter 3rdrevolution.com under Delete domain security policies and press the Delete button.

Now go to `chrome://settings/clearBrowserData`, tick the box Cached images and files and press click the button Clear data.

---

https://www.3rdrevolution.com sends the Strict-Transport-Security header so accessing it over https once will make browsers like Chrome/Firefox redirect http requests to https until some specified point in the future.

As the other answer said, the only way to stop this once it starts is to clear the browser cache (or wait for the browser to expire the order).