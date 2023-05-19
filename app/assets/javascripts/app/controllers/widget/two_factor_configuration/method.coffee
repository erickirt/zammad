class App.TwoFactorConfigurationMethod extends App.Controller
  passwordCheck: true

  constructor: (params) ->
    super

    modalOptions =
      container: params.container
      successCallback: params.successCallback

    # In after auth mode, prevent the user from canceling the modal,
    #   and bind the cancel handler to return back to after auth modal.
    if params.mode is 'after_auth'
      @passwordCheck = false
      modalOptions = _.extend(
        {},
        modalOptions,
        backdrop: 'static'
        buttonClose: false
        buttonCancel: __('Go Back')
        keyboard: false
        onCancel: ->
          new App.AfterAuthTwoFactorConfiguration(
            noFadeTransition: true
          )
      )

    # Show password check first, if requested.
    if @passwordCheck
      return new App.TwoFactorConfigurationModalPasswordCheck(
        _.extend(
          {},
          modalOptions,
          nextModalClass: @methodModalClass
        )
      )

    constructor = @methodModalClass()

    # Show method set up modal.
    new constructor(
      _.extend(
        {},
        modalOptions,
      )
    )

  methodModalClass: ->
    throw 'You need to implement methodModalClass() method'
