import { BranchesOutlined, HeatMapOutlined, PhoneOutlined } from '@ant-design/icons';
import type { MenuProps } from 'antd';
import { Layout, Menu } from 'antd';
import { Partner } from 'constants/partner';
import { usePartnerContext } from 'context/PartnerContext';
import Link from 'next/link';
import { useRouter } from 'next/router';
import * as React from 'react';
import styled from 'styled-components';
import { Route } from '../constants/routes';
import Logo from './Logo';

const { Sider } = Layout;

const LogoContainer = styled.div`
	margin-top: 1.5rem;
`;

const StyledSider = styled(Sider)`
	overflow: 'auto';
	height: '100vh';
	position: 'sticky';
	top: 0;
	left: 0;
`;

type MenuItem = Required<MenuProps>['items'][number];

function getItem(
	key: React.Key,
	title?: React.ReactNode,
	label?: React.ReactNode,
	icon?: React.ReactNode,
	children?: MenuItem[],
	type?: 'group'
): MenuItem {
	return {
		key,
		title,
		icon,
		children,
		label,
		type,
	} as MenuItem;
}

const Navbar: React.FC = () => {
	const router = useRouter();
	const { partner } = usePartnerContext();

	const items: MenuProps['items'] = [
		getItem(
			`${Route.HOME}`,
			'Emergency Operations & Outreach Dashboard',
			<Link href={Route.HOME}>
				<BranchesOutlined />
			</Link>
		),
		getItem(
			`${Route.OPERATIONS}`,
			'Event Categories',
			<Link href={Route.OPERATIONS}>
				<HeatMapOutlined />
			</Link>
		),
	];

	return (
		<StyledSider collapsed={true}>
			<LogoContainer>
				<Logo />
			</LogoContainer>
			<Menu
				theme='dark'
				mode='inline'
				defaultSelectedKeys={['/']}
				selectedKeys={[router.basePath, router.pathname]}
				items={
					partner.name === Partner.SDGE
						? [
							getItem(
								`${Route.CCC}`,
								'Customer Call Center Analytics Dashboard',
								<Link href={Route.CCC}>
									<PhoneOutlined />
								</Link>
							),
							...items,
						]
						: items
				}
			/>
		</StyledSider>
	);
};

export default Navbar;
