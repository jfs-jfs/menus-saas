import * as React from 'react';
import {act} from 'react';
import MessageCard from '@/src/interfaces/components/MessageCard';
import { Text } from '@/src/interfaces/components/Themed';
import renderer from 'react-test-renderer';

describe('MessageCard',  () => {
    it("renders correctly with given text", () => {
      act(() => {

        const tree = renderer.create(<MessageCard text="Hello World" />).toJSON();
        expect(tree).toMatchSnapshot();
      });
      });

    it("renders the passed text", async () => {
        act(() => {
            testRenderer = renderer.create(<MessageCard text="Test Message" />);
        });
        // const testRenderer = renderer.create(<MessageCard text="Test Message" />);
        const testInstance = testRenderer.root;

        expect(testInstance.findByPropos({
          className: "pene"
        }).children).toBe("Test Message");
      })
});
