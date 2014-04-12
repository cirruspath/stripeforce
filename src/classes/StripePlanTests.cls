@isTest
public class StripePlanTests {

	public static String testData_getPlan {
		get {
			return '{'+
			'  "interval": "year",'+
			'  "name": "Cirrus Insight Annual Subscription",'+
			'  "created": 1354825845,'+
			'  "amount": 0,'+
			'  "currency": "usd",'+
			'  "id": "CI_ANNUALLY",'+
			'  "object": "plan",'+
			'  "livemode": false,'+
			'  "interval_count": 1,'+
			'  "trial_period_days": null,'+
			'  "statement_description": null'+
			'}';
		}
	}

	public static String testData_getPlanList {
		get {
			return '{'+
			'  "object": "list",'+
			'  "url": "/v1/plans",'+
			'  "has_more": false,'+
			'  "data": ['+
			'    {'+
			'    "interval": "year",'+
			'    "name": "Cirrus Insight Annual Subscription",'+
			'    "created": 1354825845,'+
			'    "amount": 0,'+
			'    "currency": "usd",'+
			'    "id": "CI_ANNUALLY",'+
			'    "object": "plan",'+
			'    "livemode": false,'+
			'    "interval_count": 1,'+
			'    "trial_period_days": null,'+
			'    "metadata": {'+
			'    },'+
			'    "statement_description": null'+
			'  }'+
			'  ]'+
			'}';
		}
	}

	private static testMethod void testParse() {
		String json = testData_getPlan;
		StripePlan plan = StripePlan.parse(json);

		System.assertEquals('year', plan.interval);
		System.assertEquals(0, plan.amount);
	}

	private static testMethod void testParseList() {
		String json = testData_getPlanList;
		StripePlanList planlist = StripePlan.parseList(json);

		System.assertEquals(1, planlist.stripeData.size());
		System.assertEquals('year', planlist.stripeData[0].interval);
		System.assertEquals(0, planlist.stripeData[0].amount);
	}

	private static testMethod void testGetPlan() {
		StripePlan plan = StripePlan.getPlan('CI_ANNUALLY');

		System.assertEquals('year', plan.interval);
		System.assertEquals(0, plan.amount);
	}

	private static testMethod void testGetPlans() {
		List<StripePlan> plans = StripePlan.getPlans();

		System.assertEquals(1, plans.size());
		System.assertEquals('year', plans[0].interval);
		System.assertEquals(0, plans[0].amount);
	}

}