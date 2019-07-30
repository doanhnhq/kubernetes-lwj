detele_kernel(){
	if [[ "${release}" == "centos" ]]; then
		rpm_total=`rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | wc -l`
		if [ "${rpm_total}" > "1" ]; then
			echo -e "检测到 ${rpm_total} 个其余内核，开始卸载..."
			for((integer = 1; integer <= ${rpm_total}; integer++)); do
				rpm_del=`rpm -qa | grep kernel | grep -v "${kernel_version}" | grep -v "noarch" | head -${integer}`
				echo -e "开始卸载 ${rpm_del} 内核..."
				rpm --nodeps -e ${rpm_del}
				echo -e "卸载 ${rpm_del} 内核卸载完成，继续..."
			done
			echo --nodeps -e "内核卸载完毕，继续..."
		else
			echo -e " 检测到 内核 数量不正确，请检查 !" && exit 1
		fi
	elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
		deb_total=`dpkg -l | grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | wc -l`
		if [ "${deb_total}" > "1" ]; then
			echo -e "检测到 ${deb_total} 个其余内核，开始卸载..."
			for((integer = 1; integer <= ${deb_total}; integer++)); do
				deb_del=`dpkg -l|grep linux-image | awk '{print $2}' | grep -v "${kernel_version}" | head -${integer}`
				echo -e "开始卸载 ${deb_del} 内核..."
				apt-get purge -y ${deb_del}
				echo -e "卸载 ${deb_del} 内核卸载完成，继续..."
			done
			echo -e "内核卸载完毕，继续..."
		else
			echo -e " 检测到 内核 数量不正确，请检查 !" && exit 1
		fi
	fi
}

installbbrplus(){
	kernel_version="4.14.129-bbrplus"
	if [[ "${release}" == "centos" ]]; then
		wget -N --no-check-certificate https://${github}/bbrplus/${release}/${version}/kernel-${kernel_version}.rpm
		yum install -y kernel-${kernel_version}.rpm
		rm -f kernel-${kernel_version}.rpm
		kernel_version="4.14.129_bbrplus" #fix a bug
	elif [[ "${release}" == "debian" || "${release}" == "ubuntu" ]]; then
		mkdir bbrplus && cd bbrplus
		wget -N --no-check-certificate http://${github}/bbrplus/debian-ubuntu/${bit}/linux-headers-${kernel_version}.deb
		wget -N --no-check-certificate http://${github}/bbrplus/debian-ubuntu/${bit}/linux-image-${kernel_version}.deb
		dpkg -i linux-headers-${kernel_version}.deb
		dpkg -i linux-image-${kernel_version}.deb
		cd .. && rm -rf bbrplus
	fi
	detele_kernel
	echo -e "${Tip} 重启VPS后，请重新运行脚本开启${Red_font_prefix}BBRplus${Font_color_suffix}"
	stty erase '^H' && read -p "需要重启VPS后，才能开启BBRplus，是否现在重启 ? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
		echo -e "${Info} VPS 重启中..."
		reboot
	fi
}

installbbrplus