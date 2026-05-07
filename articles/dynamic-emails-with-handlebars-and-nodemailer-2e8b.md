---
title: "Dynamic emails with handlebars and nodemailer"
url: "https://dev.to/nsmet/dynamic-emails-with-handlebars-and-nodemailer-2e8b"
author: "Nick Smet"
category: "templatized-software"
---
# Dynamic emails with handlebars and nodemailer
**Author:** Nick Smet  **Published:** February 10, 2023

## Overview
Presents a browser-based preview application allowing developers to draft HTML email templates with Handlebars variable placeholders, test them with sample data, and send test emails through Mailtrap without using external email marketing platforms.

## Key Concepts
- **Handlebars Templating**: Dynamic content insertion in emails using double-bracket syntax; template compiler processes variables and supports conditional logic and loops
- **Monaco Editor**: Selected as the code editor component (the foundation of VSCode); provides syntax highlighting, autocomplete for HTML/Handlebars editing
- **Mailtrap Integration**: Send test emails to Mailtrap inbox using API credentials
- **Live Preview**: Application updates email previews instantly as developers modify templates and test data

```typescript
import Editor from "@monaco-editor/react";

interface Props {
    code: string;
    onChange: (code: string) => void;
}

function MyEditor(props: Props) {
  return (
      <Editor
          value={props.code}
          language="handlebars"
          defaultValue="Please enter HTML code."
          theme="vs-dark"
          onChange={(newvalue?: string) => props.onChange(newvalue || '')}
      />
  );
}

export default MyEditor;
```

```javascript
import Handlebars from 'handlebars';
const data = {
    name: "John"
}

const handlebarsTemplate = Handlebars.compile(YOUR_HTML);
const parsedHtml = handlebarsTemplate(data);
```

```html
Your HTML code
...
<p>{{name}}</p>
...
```

```json
{
    "name":"Satoshi Nakamoto"
}
```

GitHub:
- Client: https://github.com/nsmet/handlebars-email-html-previewer
- Server: https://github.com/nsmet/mailtrap-node-relay
Demo: https://handlebars-email-html-previewer.vercel.app/
