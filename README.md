# Coweave

This helps you write intereactive fiction using an AI co-writer and director. Currently, this is not hosted anywhere, so you can only run this locally, and it's more a "proof of concept" rather than a real application. Please read the [post here](TBD) for more info.

## Get started

1. Get an [API key from OpenAI](https://platform.openai.com/settings/organization/api-keys).
2. `bin/rails credentials:edit`, and copy/paste the key like this into your editor, save and close the file.

```
openai:
  access_token: sk-proj-XXXXXXX
```

3. `bin/setup`
4. Go to http://localhost:3000 to see the existing story, and edit it as you wish!
