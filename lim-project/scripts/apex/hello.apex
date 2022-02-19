Map<String,String> mapString = new Map<String,String>();
mapString.put('developerName','mydev');
mapString.put('endPoint','https://www.google.com');
mapString.put('principalType','NamedUser');
mapString.put('principalType','OAuth 2.0');

new NamedCredentialsHelper().createNC(mapString);