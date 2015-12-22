require 'spec_helper'
describe 'gitfusion' do

  context 'testing with Redhat 6' do
    let(:facts) {{
        :osfamily                  => 'RedHat',
        :operatingsystem           => 'RedHat',
        :operatingsystemmajrelease => '6'
    }}

    context 'with required params only' do
      let(:params) {{
        :p4super          => 'p4admin',
        :p4super_password => 'p@ssw0rd',
        :gfp4_password    => 'p@ssw0rd'
      }}
      it { is_expected.to compile.with_all_deps }
      it { is_expected.to contain_package('helix-git-fusion')}
    end

  end

end
