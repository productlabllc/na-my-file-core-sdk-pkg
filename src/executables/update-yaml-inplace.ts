#!/usr/bin/env node

import { updateCFYamlPropertyInplace } from '../lib/cf-yaml-helper';
import minimist from 'minimist';

const argv = minimist(process.argv.slice(2));
const { pathToYaml, propertyPath, propertyValue, help } = argv;

if (help) {
  console.log(`
    Usage:
    npx update-yaml-inplace {options}
  
    Options:
    --pathToYaml: Full path to the yaml file to update (i.e. /home/user/app.yaml)
    --propertyPath Dot-notated path reference to the property to change (i.e. User.Address.City, Account.Contact.Email)
    --propertyValue Value to be replaced at that property path
  `);
} else {
  updateCFYamlPropertyInplace(pathToYaml, propertyPath, propertyValue);
}