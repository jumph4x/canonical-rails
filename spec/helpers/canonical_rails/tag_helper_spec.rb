require 'spec_helper'

describe CanonicalRails::TagHelper, type: :helper do
  before(:each) do
    controller.request.host = 'www.alternative-domain.com'
    controller.request.path = '/our_resources'
  end

  after(:each) do
    CanonicalRails.class_variable_set(:@@sym_collection_actions, nil)
    CanonicalRails.class_variable_set(:@@sym_whitelisted_parameters, nil)
  end

  # Default behavior
  describe 'w/ default config' do
    it 'should infer the domain name by looking at the request' do
      expect(helper.canonical_host).to eq 'www.alternative-domain.com'
    end

    it 'should infer the port by looking at the request' do
      allow(controller.request).to receive(:port) { 3000 }
      expect(helper.canonical_port).to eq 3000
    end

    it 'should return no whitelisted params' do
      expect(helper.whitelisted_params).to eq({})
    end

    it 'should return a nil whitelisted query string' do
      expect(helper.whitelisted_query_string).to be_nil
    end

    it 'should infer the protocol by looking at the request' do
      expect(helper.canonical_protocol).to eq 'http://'
    end

    describe 'on a collection action' do
      before(:each) do
        controller.request.path_parameters = { controller: 'our_resources', action: 'index' }
      end

      it 'should assume we want a trailing slash' do
        expect(helper).to be_trailing_slash_needed
      end

      it 'should output a canonical tag w/ trailing slash' do
        expect(helper.canonical_href.last).to eq '/'
      end

      context "with force_trailing_slash_at_end_of_url set to false" do
        it 'removes it' do
          expect(helper.canonical_href(controller.request.host, controller.request.port, false).last).to_not eq '/'
        end
      end

      context "with the html extension in the url" do
        before(:each) do
          controller.request.path += '.html'
        end

        it "removes it" do
          expect(helper.canonical_href).to_not include '.html'
        end
      end
    end

    describe 'on a member action' do
      before(:each) do
        controller.request.path_parameters = { controller: 'our_resources', action: 'show' }
      end

      it 'should refuse trailing slash' do
        expect(helper).to_not be_trailing_slash_needed
      end

      it 'should output a canonical tag w/out trailing slash' do
        expect(helper.canonical_href.last).to_not eq '/'
      end

      context "with force_trailing_slash_at_end_of_url set to true" do
        it 'adds the trailing slash' do
          expect(helper.canonical_href(controller.request.host, controller.request.port, true).last).to eq '/'
        end
      end

      context "with the html extension in the url" do
        before(:each) do
          controller.request.path += '.html'
        end

        it "removes it" do
          expect(helper.canonical_href).to_not include '.html'
        end
      end
    end
  end

  # Customized behavior
  describe 'w/ custom config' do
    before(:each) do
      CanonicalRails.host = 'www.mywebstore.com'
      CanonicalRails.port = nil
    end

    describe 'on both types of actions' do
      it 'should take the domain from the config' do
        expect(helper.canonical_host).to eq 'www.mywebstore.com'
      end

      it 'should take the port from the config' do
        CanonicalRails.port = 3000
        expect(helper.canonical_port).to eq 3000
      end
    end

    describe 'with host and port' do
      before(:each) do
        CanonicalRails.port = 3000
        controller.request.path_parameters = { controller: 'our_resources', action: 'show' }
      end

      describe '#canonical_href' do
        it 'uses specified host and protocol' do
          expect(helper.canonical_href).to eq 'http://www.mywebstore.com:3000/our_resources'
        end
      end

      describe '#canonical_tag' do
        it 'uses specified host and protocol' do
          expect(helper.canonical_tag).to include 'http://www.mywebstore.com:3000/our_resources'
        end
      end
    end

    describe 'with a specified protocol' do
      before(:each) do
        CanonicalRails.protocol = 'https://'
        controller.request.path_parameters = { controller: 'our_resources', action: 'show' }
        allow(controller.request).to receive(:port) { 443 }
      end

      after(:each) do
        CanonicalRails.protocol = nil
      end

      describe '#canonical_href' do
        subject { helper.canonical_href }

        it 'uses specified protocol' do
          is_expected.to eq 'https://www.mywebstore.com/our_resources'
        end
      end

      describe '#canonical_tag' do
        subject { helper.canonical_tag }

        it 'uses specified protocol' do
          is_expected.to include 'https://'
        end
      end
    end

    describe 'with parameters' do
      let(:params) do
        ActionController::Parameters.new 'i-will' => 'kill-your-seo',
                                         'page' => '5',
                                         'keywords' => '"here be dragons"',
                                         'search' => { 'super' => 'special' }
      end

      before(:each) do
        CanonicalRails.whitelisted_parameters = ['page', 'keywords', 'search']
        allow_any_instance_of(controller.class).to receive(:params).and_return(params)
        controller.request.path_parameters = { controller: 'our_resources', action: 'index' }
      end

      it 'should not include random params' do
        expect(helper.whitelisted_params['i-will']).to be_nil
      end

      it 'should include whitelisted params' do
        expect(helper.whitelisted_params['page']).to eq '5'
        expect(helper.whitelisted_params['keywords']).to eq '"here be dragons"'
      end

      it 'should escape whitelisted params properly' do
        expect(helper.whitelisted_query_string).to eq '?page=5&keywords=%22here+be+dragons%22&search[super]=special'
      end

      it 'should output whitelisted params using proper syntax (?key=value&key=value)' do
        expect(helper.canonical_tag).to eq '<link href="http://www.mywebstore.com/our_resources/?page=5&keywords=%22here+be+dragons%22&search[super]=special" rel="canonical" />'
      end

      describe 'on a collection action' do
        before(:each) do
          controller.request.path_parameters = { controller: 'our_resources', action: 'index' }
        end

        it 'should output a canonical tag w/ trailing slash' do
          expect(helper.canonical_href).to include '/?'
        end
      end

      describe 'on a member action' do
        before(:each) do
          controller.request.path_parameters = { controller: 'our_resources', action: 'show' }
        end
        it 'should output a canonical tag w/out trailing slash' do
          expect(helper.canonical_href).to_not include '/?'
        end
      end
    end
  end

  describe 'when host is specified' do
    before(:each) do
      controller.request.path_parameters = { controller: 'our_resources', action: 'show' }
    end

    describe '#canonical_href' do
      subject { helper.canonical_href('www.foobar.net') }

      it 'uses provided host' do
        is_expected.to eq 'http://www.foobar.net/our_resources'
      end
    end

    describe '#canonical_tag' do
      subject { helper.canonical_tag('www.foobar.net') }

      it 'uses provided host' do
        is_expected.to include 'www.foobar.net'
      end
    end
  end

  describe 'when host and port are specified' do
    before(:each) do
      controller.request.path_parameters = { controller: 'our_resources', action: 'show' }
    end

    describe '#canonical_href' do
      subject { helper.canonical_href('www.foobar.net', 3000) }

      it 'uses provided host' do
        is_expected.to eq 'http://www.foobar.net:3000/our_resources'
      end
    end

    describe '#canonical_tag' do
      subject { helper.canonical_tag('www.foobar.net', 3000) }

      it 'uses provided host' do
        is_expected.to include 'www.foobar.net:3000'
      end
    end
  end

  describe 'when opengraph url tag is turned on' do
    before(:each) do
      CanonicalRails.opengraph_url = true
      controller.request.path_parameters = { controller: 'our_resources', action: 'show' }
    end

    describe '#canonical_tag' do
      subject { helper.canonical_tag }

      it 'outputs an og:url meta tag' do
        is_expected.to include 'property="og:url"'
      end
    end
  end

  describe 'when request action not present' do
    # Occurs if middleware tries to render a controller action before having gone through the ActionDispatch router

    describe 'on a collection action' do
      before(:each) do
        controller.request.path_parameters = {}
      end

      it 'should assume we dont want a trailing slash' do
        expect(helper).not_to be_trailing_slash_needed
      end
    end
  end
end
