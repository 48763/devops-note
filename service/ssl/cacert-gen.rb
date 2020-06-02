require "pathname"
require "fileutils"

class Cacert_gen

  def initialize
    @etc = Pathname.new("./")
  end

  def openssldir
    @etc/"openssl"
  end

  def post_install
    openssldir.mkpath
    
    keychains = %w[
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    certs_list = `security find-certificate -a -p #{keychains.join(" ")}`
    certs = certs_list.scan(
      /-----BEGIN CERTIFICATE-----.*?-----END CERTIFICATE-----/m,
    )

    certs.select do |cert|
      (openssldir/"cert.pem").write(cert+"\n", mode: 'a')
    end
  end

end

gen = Cacert_gen.new
gen.post_install