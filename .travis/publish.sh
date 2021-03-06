rm -rf output

# Writes the license key in a file
# Assumes that $LICENSE_KEY contains the license key with all /n's replaced by @@
printf "%s" "$LICENSE_KEY" > tools/oxygen-publishing-engine-3.x/licensekey.txt
sed -i 's/@@/\n/g' tools/oxygen-publishing-engine-3.x/licensekey.txt

tools/oxygen-publishing-engine-3.x/bin/dita -i dita/index/oxygen-feedback-demo.ditamap -f webhelp-responsive -o output/ -t temp/index/ -Dwebhelp.publishing.template.descriptor=index.opt -Dwebhelp.publishing.template=publishing/index/

tools/oxygen-publishing-engine-3.x/bin/dita -i dita/garage/garage.ditamap -f webhelp-responsive -o output/garage/1.0/ -t temp/garage/1.0 -Dwebhelp.publishing.template.descriptor=material.opt -Dwebhelp.publishing.template=publishing/material/

tools/oxygen-publishing-engine-3.x/bin/dita -i dita/flowers/flowers.ditamap -f webhelp-responsive -o output/flowers/1.0/ -t temp/flowers/1.0 -Dwebhelp.publishing.template.descriptor=flowers-tiles.opt -Dwebhelp.publishing.template=publishing/flowers/

tools/oxygen-publishing-engine-3.x/bin/dita -i dita/space-videos/space-videos.ditamap -f webhelp-responsive -o output/space-videos/1.0/ -t temp/space-videos/1.0 -Dwebhelp.publishing.template.descriptor=space-videos.opt -Dwebhelp.publishing.template=publishing/space-videos/

tools/oxygen-publishing-engine-3.x/bin/dita -i dita/mobile-phone/mobilePhone.ditamap -filter=dita/mobile-phone/ditaval/x1000.ditaval -f webhelp-responsive -o output/mobile-phone/1.0/ -t temp/mobile-phone/1.0 -Dwebhelp.publishing.template.descriptor=hightech.opt -Dwebhelp.publishing.template=publishing/hightech/ -Dwebhelp.fragment.feedback=$PWD/dita/mobile-phone/v1.0-feedback-fragment.xml

tools/oxygen-publishing-engine-3.x/bin/dita -i dita/mobile-phone/mobilePhone.ditamap -filter=dita/mobile-phone/ditaval/x2000.ditaval -f webhelp-responsive -o output/mobile-phone/2.0/ -t temp/mobile-phone/2.0 -Dwebhelp.publishing.template.descriptor=hightech.opt -Dwebhelp.publishing.template=publishing/hightech/ -Dwebhelp.fragment.feedback=$PWD/dita/mobile-phone/v2.0-feedback-fragment.xml
