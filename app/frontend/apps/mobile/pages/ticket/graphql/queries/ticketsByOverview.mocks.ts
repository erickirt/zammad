import * as Types from '#shared/graphql/types.ts';

import * as Mocks from '#tests/graphql/builders/mocks.ts'
import * as Operations from './ticketsByOverview.api.ts'
import * as ErrorTypes from '#shared/types/error.ts'

export function mockTicketsByOverviewQuery(defaults: Mocks.MockDefaultsValue<Types.TicketsByOverviewQuery, Types.TicketsByOverviewQueryVariables>) {
  return Mocks.mockGraphQLResult(Operations.TicketsByOverviewDocument, defaults)
}

export function waitForTicketsByOverviewQueryCalls() {
  return Mocks.waitForGraphQLMockCalls<Types.TicketsByOverviewQuery>(Operations.TicketsByOverviewDocument)
}

export function mockTicketsByOverviewQueryError(message: string, extensions: {type: ErrorTypes.GraphQLErrorTypes }) {
  return Mocks.mockGraphQLResultWithError(Operations.TicketsByOverviewDocument, message, extensions);
}
