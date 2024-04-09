export default {
  "openapi": "3.0.0",
  "info": {
    "title": "My File NYC",
    "description": "This api represents a combination of all API Gateway Lambda Proxy components for My File NYC.",
    "contact": {
      "email": "wereid@nycopportunity.nyc.gov"
    },
    "license": {
      "name": "Apache 2.0",
      "url": "http://www.apache.org/licenses/LICENSE-2.0.html"
    },
    "version": "1.0.0"
  },
  "servers": [
    {
      "url": "https://api.dev.myfile.cityofnewyork.us/",
      "description": "My File NYC API (dev)"
    },
    {
      "url": "https://api.staging.myfile.cityofnewyork.us/",
      "description": "My File NYC API (staging)"
    }
  ],
  "tags": [
  ] as Array<string>,
  "security": [
    {
      "bearerAuth": []
    }
  ],
  "paths": {} as any,
  "components": {
    "securitySchemes": {
      "bearerAuth": {
        "type": "http",
        "scheme": "bearer",
        "bearerFormat": "JWT"
      }
    }
  },
};