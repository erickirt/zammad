import * as Types from '#shared/graphql/types.ts';

import * as Mocks from '#tests/graphql/builders/mocks.ts'
import * as Operations from './userAddFirstAdmin.api.ts'
import * as ErrorTypes from '#shared/types/error.ts'

export function mockUserAddFirstAdminMutation(defaults: Mocks.MockDefaultsValue<Types.UserAddFirstAdminMutation, Types.UserAddFirstAdminMutationVariables>) {
  return Mocks.mockGraphQLResult(Operations.UserAddFirstAdminDocument, defaults)
}

export function waitForUserAddFirstAdminMutationCalls() {
  return Mocks.waitForGraphQLMockCalls<Types.UserAddFirstAdminMutation>(Operations.UserAddFirstAdminDocument)
}

export function mockUserAddFirstAdminMutationError(message: string, extensions: {type: ErrorTypes.GraphQLErrorTypes }) {
  return Mocks.mockGraphQLResultWithError(Operations.UserAddFirstAdminDocument, message, extensions);
}
