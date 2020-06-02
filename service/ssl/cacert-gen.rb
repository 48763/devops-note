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
      IO.popen("openssl x509 -inform pem -checkend 0 -noout >/dev/null", "w") do |openssl_io|
        openssl_io.write(cert)
        openssl_io.close_write
      end
        if ($?.success?)
          (openssldir/"cert.pem").write(cert+"\n", mode: 'a')
        end
    end
  end

end

gen = Cacert_gen.new
gen.post_install