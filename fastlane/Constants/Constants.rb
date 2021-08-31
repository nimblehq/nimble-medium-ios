# frozen_string_literal: true

class Constants
  #################
  #### PROJECT ####
  #################

    #Project path
  def self.PROJECT_PATH
    './NimbleMedium.xcodeproj'
  end

  def self.BUNDLE_ID_STAGING
    'co.nimblehq.nimble-medium-stag'
  end

  def self.BUNDLE_ID_PRODUCTION
    'co.nimblehq.nimble-medium'
  end

  #################
  #### BUILDING ###
  #################

  # a derived data path
  def self.DERIVED_DATA_PATH
    './DerivedData'
  end

  # a build path
  def self.BUILD_PATH
    './Build'
  end

  #################
  #### TESTING ####
  #################

  # a device name
  def self.DEVICE
    ENV.fetch('DEVICE', 'iPhone 12 Pro Max')
  end

  # a scheme name for unit testing
  def self.UNIT_TESTS_SCHEME
    'NimbleMedium Staging'
  end

  ##################
  #### FIREBASE ####
  ##################

  # a gsp files directory
  def self.GSP_DIRECTORY
    './'
  end

  # a gsp file name for staging
  def self.GSP_STAGING
    './NimbleMedium/Configurations/Plists/GoogleService/Staging/GoogleService-Info.plist'
  end

  # a gsp file name for production
  def self.GSP_PRODUCTION
    './NimbleMedium/Configurations/Plists/GoogleService/Production/GoogleService-Info.plist'
  end

  # The path to the upload-symbols file of the Fabric app
  def self.BINARY_PATH
    './Pods/FirebaseCrashlytics/upload-symbols'
  end

  # a firebase app ID for Staging
  def self.FIREBASE_APP_ID_STAGING
    '1:551877598585:ios:56491a798de96b093da3a8'
  end

  # a firebase app ID for Production
  def self.FIREBASE_APP_ID_PRODUCTION
    '{PROJECT_FIREBASE_APP_ID}'
  end

  def self.FIREBASE_TESTER_GROUPS
    "nimble-dev"
  end

  #################
  ### ARCHIVING ###
  #################

   # a developer portal team id
  def self.DEV_PORTAL_TEAM_ID
    '4TWS7E2EPE'
  end

  # an staging environment scheme name
  def self.SCHEME_NAME_STAGING
    'NimbleMedium Staging'
  end

  # a Production environment scheme name
  def self.SCHEME_NAME_PRODUCTION
    'NimbleMedium'
  end

  # a App Store environment scheme name
  def self.SCHEME_NAME_APP_STORE
    'NimbleMedium AppStore'
  end

  # an staging product name
  def self.PRODUCT_NAME_STAGING
    'NimbleMedium Staging'
  end

  # a staging TestFlight product name
  def self.PRODUCT_NAME_STAGING_TEST_FLIGHT
    'NimbleMedium TestFlight'
  end

  # a Production product name
  def self.PRODUCT_NAME_PRODUCTION
    'NimbleMedium'
  end

  # a main target name
  def self.MAIN_TARGET_NAME
    'NimbleMedium'
  end

  ##################
  ### DEV PORTAL ###
  ##################

  def self.DEV_PORTAL_APPLE_ID
    'thuong@nimblehq.co'
  end

  #####################
  ### App Store API ###
  #####################

  # App Store Connect API Key ID
  def self.APP_STORE_KEY_ID
    '{API_KEY_ID}'
  end

  # App Store Connect API Issuer ID
  def self.APP_STORE_ISSUER_ID
    '{ISSUER_ID}'
  end

end
