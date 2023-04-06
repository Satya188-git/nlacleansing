import IEvent from './event';

export default interface IOperationEvents {
	category: string;
	events: IEvent[];
}
