describe("E2E: Testing main controllers", function() {
  beforeEach(function() {
        browser().navigateTo('/app/index.html');
  });

  it('check HP' , function() {
    expect(element('h1').html()).toContain('Welcome to ci-dashboard')
  });
});
