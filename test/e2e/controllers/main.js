describe("E2E: Testing main controllers", function() {
  beforeEach(function() {
        browser().navigateTo('/app/index.html');

  });

    it('check HP', function() {
    	expect(element('h1').html()).toContain('Welcome to ci-dashboard')

    });

	it('check Dash selection', function() {
		select('selected').option('exampleDash');
		element('.btn-info').click();
		expect(element('h5').html()).toContain('exampleDash')
		expect(browser().location().path(), '/dashboard/exampleDash');
	});
});
