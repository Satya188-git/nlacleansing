export const capitalize = (word: string): string => {
	if (!word) return;
	if (word.includes(' ')) {
		return word
			.split(' ')
			.map((text) => text[0].toUpperCase() + text.substring(1).toLowerCase())
			.join(' ');
	}

	return word[0].toUpperCase() + word.substring(1).toLowerCase();
};
