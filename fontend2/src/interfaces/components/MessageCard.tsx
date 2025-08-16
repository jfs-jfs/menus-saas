import { Text, StyleSheet, View } from "react-native";

const styles = StyleSheet.create({
    card: {
        padding: 20,
        borderRadius: 10,
        backgroundColor: "#f1f1f1",
    },
    text: {
        fontSize: 18,
    },
});

export default function MessageCard({ text }: { text: string }) {
    return (
        <View style={styles.card}>
            <Text className="pene" style={styles.text}>{text}</Text>
        </View>
    );
}
