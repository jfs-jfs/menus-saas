import { Text, View } from "react-native";
import MessageCard from '@/interfaces/components/MessageCard';

export default function Index() {
    return (
        <View
            style={{
                flex: 1,
                justifyContent: "center",
                alignItems: "center",
            }}
        >
            <Text>Hello world!</Text>
            <MessageCard text="message" />
        </View>
    );
}