#!/bin/bash

govc vm.power -s "${VM_NAME}"

while true
do
     echo "Waiting for VM to power off..."

     if [[ "$(govc vm.info -json "${VM_NAME}" | jq -r '.virtualMachines[].runtime.powerState')" == "poweredOff" ]]
     then
          break
     fi

     sleep 2
done

echo "Removing CD-ROM drive"
govc device.remove -vm "${VM_NAME}" $(govc device.ls -vm "${VM_NAME}" | grep cdrom | awk '{print $1}')

# Add any PCI devices. Can't seem to do this via vsphere_virtual_machine because it complains about not having the VM's
# ID during provision time.
if [ ! -z "${PCI_DEVICE_IDS}" ]
then
     for PCI_DEVICE_ID in $PCI_DEVICE_IDS; do
          echo "Adding PCI device '${PCI_DEVICE_ID}'"
          govc device.pci.add -vm "${VM_NAME}" "${PCI_DEVICE_ID}"
     done
fi

govc vm.power -on "${VM_NAME}"
