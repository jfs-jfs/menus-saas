import { render } from '@testing-library/react-native';
import MessageCard from '@/interfaces/components/MessageCard';

describe('MessageCard', () => {
    it('renders the text correctly', () => {
        const { getByText } = render(<MessageCard text="Test message" />);
        expect(getByText('Test message')).toBeTruthy();
    });
});