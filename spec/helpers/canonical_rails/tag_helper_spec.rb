require 'spec_helper'

describe CanonicalRails::TagHelper do

  before(:each) do
    controller.request.host = 'www.alternative-domain.com'
    controller.request.path = '/our_resources'
  end

  after(:each) do
    CanonicalRails.class_variable_set(:@@sym_whitelisted_actions, nil)
    CanonicalRails.class_variable_set(:@@sym_collection_actions, nil)
  end

  # Default behavior
  describe 'w/ default config' do

    it 'should take the domain from the config' do
      helper.canonical_host.should == 'www.alternative-domain.com'
    end

    it 'should return no whitelisted params' do
      helper.whitelisted_params.should == {}
    end

    it 'should return a nil whitelisted query string' do
      helper.whitelisted_query_string.should be_nil
    end

    it 'should infer the protocol by looking at the request' do
      helper.canonical_protocol.should == 'http://'
    end

    describe 'on a collection action' do
      before(:each) do
        controller.request.path_parameters = {'controller' => 'our_resources', 'action' => 'index'}
      end

      it 'should assume we want a trailing slash' do
        helper.trailing_slash_needed?.should be_true
      end

      it 'should output a canonical tag w/ trailing slash' do
        helper.canonical_href.last.should == '/'
      end

      context "with the html extension in the url" do
        before(:each) do
          controller.request.path += ".html"
        end

        it "removes it" do
          helper.canonical_href.should_not include(".html")
        end
      end
    end

    describe 'on a member action' do
      before(:each) do
        controller.request.path_parameters = {'controller' => 'our_resources', 'action' => 'show'}
      end

      it 'should refuse trailing slash' do
        helper.trailing_slash_needed?.should be_false
      end

      it 'should output a canonical tag w/out trailing slash' do
        helper.canonical_href.last.should_not == '/'
      end

      context "with the html extension in the url" do
        before(:each) do
          controller.request.path += ".html"
        end

        it "removes it" do
          helper.canonical_href.should_not include(".html")
        end
      end
    end
  end



  # Customized behavior
  describe 'w/ custom config' do
    before(:each) do
      CanonicalRails.host = 'www.mywebstore.com'
    end

    describe 'on both types of actions' do
      it 'should infer the domain name by looking at the request' do
        helper.canonical_host.should == 'www.mywebstore.com'
      end
    end

    describe 'with a specified protocol' do
      before(:each) do
        CanonicalRails.protocol = 'https://'
        controller.request.path_parameters = {'controller' => 'our_resources', 'action' => 'show'}
      end

      after(:each) do
        CanonicalRails.protocol = nil
      end

      describe '#canonical_href' do
        subject{ helper.canonical_href }
        it 'uses specified protocol' do
          should eq('https://www.mywebstore.com/our_resources')
        end
      end

      describe '#canonical_tag' do
        subject{ helper.canonical_tag }
        it 'uses specified protocol' do
          should include('https://')
        end
      end

    end

    describe 'with parameters' do
      before(:each) do
        CanonicalRails.whitelisted_parameters = ['page', 'keywords', 'search']
        controller.request.stub!(:query_parameters).and_return({'i-will' => 'kill-your-seo', 'page' => '5', 'keywords' => '"here be dragons"', 'search' => { 'super' => 'special' }})
        controller.request.path_parameters = {'controller' => 'our_resources', 'action' => 'index'}
      end

      it 'should not include random params' do
        helper.whitelisted_params['i-will'].should be_nil
      end

      it 'should include whitelisted params' do
        helper.whitelisted_params['page'].should == '5'
        helper.whitelisted_params['keywords'].should == '"here be dragons"'
      end

      it 'should escape whitelisted params properly' do
        helper.whitelisted_query_string.should == '?page=5&keywords=%22here+be+dragons%22&search[super]=special'
      end

      it 'should output whitelisted params using proper syntax (?key=value&key=value)' do
        helper.canonical_tag.should == '<link href="http://www.mywebstore.com/our_resources/?page=5&keywords=%22here+be+dragons%22&search[super]=special" rel="canonical" />'
      end

      describe 'on a collection action' do
        before(:each) do
          controller.request.path_parameters = {'controller' => 'our_resources', 'action' => 'index'}
        end

        it 'should output a canonical tag w/ trailing slash' do
          helper.canonical_href.should include('/?')
        end
      end

      describe 'on a member action' do
        before(:each) do
          controller.request.path_parameters = {'controller' => 'our_resources', 'action' => 'show'}
        end
        it 'should output a canonical tag w/out trailing slash' do
          helper.canonical_href.should_not include('/?')
        end
      end
    end
  end

  describe 'when host is specified' do
    before(:each) do
      controller.request.path_parameters = {'controller' => 'our_resources', 'action' => 'show'}
    end

    describe '#canonical_href' do
      subject{ helper.canonical_href('www.foobar.net') }
      it 'uses provided host' do
        should eq('http://www.foobar.net/our_resources')
      end
    end

    describe '#canonical_tag' do
      subject{ helper.canonical_tag('www.foobar.net') }
      it 'uses provided host' do
        should include('www.foobar.net')
      end
    end
  end
end
