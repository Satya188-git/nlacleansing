import { AWS_URL } from 'constants/url';
import Link from 'next/link';
import styled from 'styled-components';
import { Route } from '../constants/routes';
import { usePartnerContext } from '../context/PartnerContext';
import Image from 'next/image';

const LogoContainer = styled.div`
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
`;

const Logo: React.FC = () => {
	const { partner } = usePartnerContext();

	const logo =
		partner.name === 'SoCalGas'
			? '/socalgas-logo.png' || `${AWS_URL.S3}socalgas-logo.png`
			: '/sdge-logo.png' || `${AWS_URL.S3}sdge-logo.png`;
	return (
		<LogoContainer>
			<Link href={Route.DASHBOARD}>
				<Image src={logo} height={50} width={65} alt="" />
			</Link>
		</LogoContainer>
	);
};

export default Logo;
