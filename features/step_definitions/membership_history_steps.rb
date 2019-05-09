Then /I should see the change of "(.*)" membership from "(.*)" to "(.*)" by "(.*)"/ do |changed, old, new_m, by|
    # td = page.find(:css, 'td.changed_name', text: changed)
    print page.body
    tr = page.find(:xpath, "/html/body/div[1]/div/div/table/tbody/tr")
    expect(tr).to have_css('td.old', text: old)
    expect(tr).to have_css('td.new', text: new_m)
    expect(tr).to have_css('td.changed_by_name', text: by)
end

And /I should see these "(.*)" "(.*)" "(.*)" "(.*)" first/ do |changed, old, new_m, by|
    tr = page.find(:xpath, ".//tbody//tr[1]")
    expect(tr).to have_css('td.changed_name', text: changed)
    expect(tr).to have_css('td.old', text: old)
    expect(tr).to have_css('td.new', text: new_m)
    expect(tr).to have_css('td.changed_by_name', text: by)
end

Then /my path should be "(.*)"/ do |pathasdf|
    current_path = URI.parse(current_url).path
    current_path.equal?(pathasdf)
end

When /I try to go to path "(.*)"/ do |path|
    session.visit(path)
end