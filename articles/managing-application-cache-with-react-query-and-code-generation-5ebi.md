---
title: "Managing application cache with react-query. And code generation from OpenAPI."
url: "https://dev.to/detoner777/managing-application-cache-with-react-query-and-code-generation-5ebi"
author: "Alexey Lysenko"
category: "templatized-software"
---
# Managing application cache with react-query. And code generation from OpenAPI.
**Author:** Alexey Lysenko  **Published:** May 31, 2022

## Overview
Discusses transitioning from Redux to react-query for state management and demonstrates how to generate custom React hooks from OpenAPI schemas using code generation. Shows how to reduce boilerplate while improving code reusability across web and mobile clients.

## Key Concepts
**Application Cache vs. State**: Cache represents external data (HTTP requests); state represents internal application data. Most application data (90%) is cache, not state.

**React-Query Fundamentals**: A library for fetching, caching, and updating data without global state management. Provides custom hooks (`useQuery`, `useMutation`) that handle loading, error, and success states.

**Code Generation Workflow**: OpenAPI schema → Custom react-query hooks. Automatically differentiates between queries (GET) and mutations (other methods). Distributes as npm packages for web and mobile clients.

**Tools Used**: oclif (CLI framework), Mustache.js (template engine), cosmiconfig (configuration management), @straw-hat/openapi-web-sdk-generator

```javascript
import { QueryClient, QueryClientProvider } from 'react-query'
const queryClient = new QueryClient()
export default function App() {
 return (
   <QueryClientProvider client={queryClient}>
     <ExampleFirst />
   </QueryClientProvider>
 )
}
```

```javascript
import { useQuery } from 'react-query'
import axios from 'axios'

function ExampleFirst() {
 const { isLoading, error, data } = useQuery('repoData', async () => {
  const res = await axios.get('https://api.github.com/repos/react-query')
  return res.data
 })
 if (isLoading) return 'Loading...'
 if (error) return 'An error has occurred: ' + error.message
 return (
   <div>
     <h1>{data.name}</h1>
     <p>{data.description}</p>
   </div>
 )
}
```

```mustache
import type { Fetcher } from '@straw-hat/fetcher';
import type { UseFetcherQueryArgs } from '@straw-hat/react-query-fetcher';
import { useFetcherQuery } from '@straw-hat/react-query-fetcher';

export function use{{{pascalFunctionName}}}<TData = {{{typePrefix}}}Response>(
  client: Fetcher,
  args: Use{{{pascalFunctionName}}}Args<TData, TError>,
) {
  return useFetcherQuery(client, {
    ...args,
    queryKey: QUERY_KEY,
    endpoint: {{{functionName}}},
  });
}
```

```yaml
generators:
  - path: "@straw-hat/openapi-web-sdk-generator/dist/generators/react-query-fetcher"
    config:
      outputDir: "src/operations"
      packageName: "@super/test"
```
