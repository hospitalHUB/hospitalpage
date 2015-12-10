<?php
use Behat\Behat\Context\Context;
use Behat\Behat\Hook\Scope\AfterStepScope;
use Behat\MinkExtension\Context\MinkContext;
use Behat\Behat\Hook\Scope\BeforeFeatureScope;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;
// use Behat\Behat\Context\TranslatedContextInterface,
// use Behat\Gherkin\Node\PyStringNode,
// Behat\Gherkin\Node\TableNode;

/**
 * Features context.
 */
class FeatureContext extends MinkContext {
	
	/**
	 * constr
	 */
	public function __construct() {
		// instantiate context
	}
	
	/**
	 * @BeforeFeature
	 */
	public static function prepareForTheFeature(BeforeFeatureScope $scope) {
		$post="---
layout: post
title: " . $scope->getFeature()->getTitle() . "
---
		
" . preg_replace("\n", "", $scope->getFeature()->getDescription()) . "
";
		FeatureContext::printToScenario($scope, $post );
	}
	
	/**
	 * @BeforeScenario
	 */
	public function prepareForTheScenario(BeforeScenarioScope $scope) {
		$text="
		# " . $scope->getScenario()->getTitle()."
		"; 
		FeatureContext::printToScenario($scope, $text);
	}
	
	public static function printToScenario($scope,$text) {
		file_put_contents( FeatureContext::getFileName($scope), $text , FILE_APPEND);
	}
	
	public static function getFileName($scope) {
		$filename = getenv("HOME") . '/' . date('Y-m-d-') . $scope->getFeature()->getTitle() . '.markdown';
		return $filename;
	}

  /**
   * @AfterStep
   */
  public function takeScreenShotAfterStep(AfterStepScope $scope)
  {
  	// filename - if the step is repeated it doesn't create additional screenshots
  	  $fileName = $scope->getFeature()->getTitle() . '-' . md5($scope->getStep()->getText()) .'-'. $scope->getStep()->getLine() . '.png';
  	  $text = "![".$scope->getStep()->getText()."]({{ site.url }}/".$fileName . ")
  	  ";
  	  FeatureContext::printToScenario($scope, $text);
  	  $this->saveScreenshot($fileName, getenv("HOME"));
  }
  
	/**
	 * @Given we have some context
	 */
	public function prepareContext() {
		// do something
	}
	
	/**
	 * @When event occurs
	 */
	public function doSomeAction() {
		// do something
	}
	
	/**
	 * @Then something should be done
	 */
	public function checkOutcomes() {
		// do something
	}
	
	/**
	 * @Given /^otwieram na ([^"]*)$/
	 */
	public function iOpenOnDevice($argument) {
		// doSomethingWith($argument);
		echo "Otwarto na: " . $argument;
		if ($argument == "smartfonie") {
			$this->getSession()->resizeWindow(320, 480, 'current');
		} else if ($argument == "tablecie") {
			$this->getSession()->resizeWindow(1024, 768, 'current');
		} else {
			$this->getSession()->resizeWindow(1280, 1024, 'current');
		}
	}
}
