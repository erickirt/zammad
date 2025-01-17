import * as Types from '#shared/graphql/types.ts';

import * as Mocks from '#tests/graphql/builders/mocks.ts'
import * as Operations from './organization.api.ts'
import * as ErrorTypes from '#shared/types/error.ts'

export function mockOrganizationQuery(defaults: Mocks.MockDefaultsValue<Types.OrganizationQuery, Types.OrganizationQueryVariables>) {
  return Mocks.mockGraphQLResult(Operations.OrganizationDocument, defaults)
}

export function waitForOrganizationQueryCalls() {
  return Mocks.waitForGraphQLMockCalls<Types.OrganizationQuery>(Operations.OrganizationDocument)
}

export function mockOrganizationQueryError(message: string, extensions: {type: ErrorTypes.GraphQLErrorTypes }) {
  return Mocks.mockGraphQLResultWithError(Operations.OrganizationDocument, message, extensions);
}
