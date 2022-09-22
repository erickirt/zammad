// Copyright (C) 2012-2022 Zammad Foundation, https://zammad-foundation.org/

import type { FormKitTypeDefinition } from '@formkit/core'
import type { FormKitSchemaExtendableSection } from '@formkit/inputs'
import { mergeArray } from '@shared/utils/helpers'
import {
  outer,
  inner,
  wrapper,
  label,
  help,
  messages,
  message,
  prefix,
  suffix,
} from '@formkit/inputs'
import { arrow } from '../sections/arrow'
import { link } from '../sections/link'
import defaulfFieldDefinition from './defaultFieldDefinition'

export interface FieldsCustomOptions {
  addDefaultProps?: boolean
  addDefaultFeatures?: boolean
  addArrow?: boolean
  schema?: () => FormKitSchemaExtendableSection
}

const initializeFieldDefinition = (
  definition: FormKitTypeDefinition,
  additionalDefinitionOptions: Pick<
    FormKitTypeDefinition,
    'props' | 'features'
  > = {},
  options: FieldsCustomOptions = {},
) => {
  const {
    addDefaultProps = true,
    addDefaultFeatures = true,
    addArrow = false,
  } = options

  const localDefinition = definition
  localDefinition.props ||= []
  localDefinition.features ||= []

  if (options.schema) {
    const wrapperSchema = wrapper(
      label('$label'),
      inner(prefix(), options.schema(), suffix()),
    )
    const outerSchema = [wrapperSchema]

    if (addArrow) {
      outerSchema.push(arrow())
    }

    outerSchema.push(link(), help('$help'), messages(message('$message.value')))

    localDefinition.schema = outer(...outerSchema)
  }

  const additionalProps = additionalDefinitionOptions.props || []
  if (addDefaultProps) {
    localDefinition.props = mergeArray(
      localDefinition.props,
      defaulfFieldDefinition.props.concat(additionalProps),
    )
  }

  const additionalFeatures = additionalDefinitionOptions.features || []
  if (addDefaultFeatures) {
    localDefinition.features = mergeArray(
      defaulfFieldDefinition.features.concat(additionalFeatures),
      localDefinition.features,
    )
  }
}

export default initializeFieldDefinition
