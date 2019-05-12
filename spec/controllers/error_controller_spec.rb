require 'rails_helper'
require 'spec_helper'
require 'error_controller'

RSpec.describe ErrorController, type: :controller do
    it 'renders an error page given invalid url' do
        get "error_404"
        expect(subject).not_to render_template(:error_404)
        expect(response).to redirect_to root_path
    end

end