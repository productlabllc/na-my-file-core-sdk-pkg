import fs from 'fs';
import { generateRouteSwaggerSpec } from '../src/lib/swagger-route-specification-generator';
import { routeSchema } from './users/get-user-by-id';
import swaggerBaseline from './swagger-baseline';
import * as apiClient from '../../my-file-api-client';
import path from 'path';

const generateOas = () => {
  const swaggerSpec = { ...swaggerBaseline };
  console.log(`routeSchema:
  ${JSON.stringify(routeSchema, null, 2)}
  `);
  const { path: swaggerPathSpec, components } = generateRouteSwaggerSpec(routeSchema, 'This is a description.');
  swaggerSpec.tags.push('users');
  let pathItem: Record<string, any> = {};
  pathItem['post'] = swaggerPathSpec;
  swaggerSpec.paths['/users/{userId}'] = {...pathItem};
  swaggerSpec.components = { ...swaggerSpec.components, ...components };
  fs.writeFileSync(path.join(__dirname, './swagger-output.json'), JSON.stringify(swaggerSpec, null, 2));
  // console.log(JSON.stringify(swaggerSpec, null, 2));
};

const testApi = async () => {
  const api = new apiClient.DefaultApi({  });
  const response = await api.createUserFile();
  console.log(api);
  
};

(() => {
  // generateOas();
  testApi();
})();