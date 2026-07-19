Feature: Magic Mirror style intelligence and shopping journey

  @SC-001 @US-001 @US-004 @US-005 @US-006 @US-007 @US-008
  Scenario: A first-time customer receives a personalized style report
    Given an adult visitor has opened the Magic Mirror landing page
    And the visitor has not created a Magic Mirror account
    When the visitor starts the style report
    And completes the personal and brand-size profile
    And uploads between 8 and 12 qualifying full-body favorite-look photos
    And completes the required taste calibration choices
    And connects the anonymous onboarding session to a permanent account with Google or a valid email magic link and required consent
    Then Magic Mirror starts real style analysis using the submitted inputs
    And shows meaningful processing stages
    And displays the completed style report when analysis finishes within 120 seconds
    And preserves the report in the new account

  @SC-002 @US-002 @US-022
  Scenario: A returning customer uses Google or a magic link to resume the correct account state
    Given a customer has a valid Magic Mirror account
    And the account has an incomplete onboarding step, active analysis, completed report, or style home
    When the customer authenticates with Google or a valid email magic link
    Then Magic Mirror routes the customer to the latest valid state
    And does not require completed onboarding work to be repeated

  @SC-003 @US-003 @US-021
  Scenario: A customer corrects an invalid personal profile
    Given a customer is completing the personal profile
    When the customer omits a required field or enters an invalid value
    Then Magic Mirror identifies the specific field and correction needed
    And preserves every valid field value
    And allows optional weight to remain unanswered
    And does not allow a person who has not confirmed adult status to continue

  @SC-004 @US-005 @US-020
  Scenario: One outfit photo fails validation without losing successful uploads
    Given a customer has successfully uploaded qualifying outfit photos
    When another image is corrupted, unsupported, duplicated, or does not show a usable full-body look
    Then Magic Mirror marks only that image as rejected
    And explains how to replace or correct it
    And preserves all successfully validated photos
    And prevents continuation only while fewer than eight qualifying images remain

  @SC-005 @US-006 @US-020
  Scenario: Taste calibration recovers from a card-loading failure
    Given a customer has recorded taste choices
    When the next look or garment cannot be loaded
    Then Magic Mirror preserves the recorded choices
    And shows an explicit retry action
    And continues from the next incomplete calibration choice after recovery

  @SC-006 @US-007
  Scenario: Anonymous progress connects to an existing permanent account
    Given a customer has completed onboarding and calibration under an anonymous authenticated identity
    When the customer authenticates with Google or a magic link for an existing Magic Mirror account
    Then Magic Mirror logs the customer into that existing account
    And connects the authorized anonymous profile, photos, and taste choices to it
    And preserves the progress if account connection is interrupted
    And does not require a separate signup flow

  @SC-007 @US-008 @US-020
  Scenario: Style analysis exceeds the two-minute target
    Given a customer has submitted valid report inputs and created an account
    When the report is not complete within 120 seconds
    Then Magic Mirror changes from processing to an explicit slow state
    And confirms that analysis is continuing
    And offers email notification and a safe way to leave
    And restores the completed report when the customer returns after completion

  @SC-008 @US-008 @US-020
  Scenario: Style analysis fails and preserves recoverable inputs
    Given a customer has submitted valid report inputs
    When the analysis provider or product system returns a failure
    Then Magic Mirror shows a normalized error, code, and human-readable details
    And preserves profile, valid photos, taste choices, and account state while they remain usable
    And offers retry or support according to the failure
    And never fails silently

  @SC-009 @US-009 @US-010 @US-011 @US-012
  Scenario: A customer explores and corrects the style report
    Given a completed report contains style identity, color, body-style, and recommendation sections
    When the customer opens each section
    Then Magic Mirror explains the finding and its practical styling implications
    And distinguishes customer-provided facts from inferred findings
    And presents Kibbe-informed guidance as interpretive rather than objective judgment
    And allows the customer to disagree, correct a fact, or request recalibration

  @SC-010 @US-014 @US-020 @US-021
  Scenario: A customer denies camera permission for live styling
    Given a customer has selected a recommended item
    When the customer starts live styling and denies camera permission
    Then Magic Mirror explains that the camera is required for the live view
    And offers a permission retry or device guidance
    And preserves access to the report, product recommendations, and selected item

  @SC-011 @US-014 @US-015 @US-021
  Scenario: A customer asks for a different live styling item by voice
    Given a customer is in a ready live styling session
    And has granted microphone permission
    When the customer asks for a different color, silhouette, brand, price range, or occasion
    Then Magic Mirror shows the interpreted request
    And confirms or safely resolves ambiguity
    And updates the recommended item set using the request and style report
    And keeps an equivalent direct refinement control available

  @SC-012 @US-016 @US-017 @US-018
  Scenario: A customer selects an item and continues to its retailer
    Given a customer is viewing a current recommended product
    When the customer adds the product to the Magic Mirror bag
    And chooses to continue to the retailer
    Then Magic Mirror explains that the retailer controls price, availability, checkout, shipping, returns, and payment
    And opens the correct current retailer destination
    And preserves the Magic Mirror report and bag state for return

  @SC-013 @US-005 @US-007 @US-019
  Scenario: Sensitive onboarding inputs remain isolated through account connection
    Given a customer has started onboarding under an anonymous authenticated identity
    And has consented to photo analysis
    When the customer uploads outfit photos and later connects a permanent account
    Then only that anonymous identity can access the inputs before connection
    And only the authorized connected account can access them after connection
    And Magic Mirror does not expose raw photos or sensitive profile values in logs

  @SC-014 @US-013 @US-022
  Scenario: A report recipient opens personalized recommendations
    Given a customer has a completed report and eligible catalog items
    When the customer opens style home or follows a report recommendation
    Then Magic Mirror shows products selected for the customer's report
    And explains the report attributes behind each match
    And allows refinement by category, color, brand, price range, or occasion
    And clearly marks or replaces an item that is no longer available

  @SC-015 @US-014 @US-021 @US-023
  Scenario: A customer changes outfits with hand gestures from a distance
    Given a customer is in a ready live styling session with camera permission
    And gesture control is active
    When the customer performs a documented gesture for the next outfit, previous outfit, or a visible control
    Then Magic Mirror shows the recognized gesture and intended action
    And changes or selects the outfit control when recognition is accepted
    And requests explicit confirmation before adding to the bag, leaving for a retailer, or ending the session
    And keeps equivalent voice and direct controls available
