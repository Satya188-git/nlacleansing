import { useRouter } from 'next/router';

export default function Media() {
	const {
		query: { id },
	} = useRouter();

	return <div>Topic - {id}</div>;
}
